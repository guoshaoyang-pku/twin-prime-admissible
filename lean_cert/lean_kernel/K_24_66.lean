import Sound
import lean_certs.cert_24_66

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H24_gt_66_kernel : ¬ ∃ t : List Nat, admissible 24 t = true ∧ diameter t ≤ 66 := by
  exact certValidRoot_sound (k := 24) (d := 66) (c := cert_24_66) (by decide)
