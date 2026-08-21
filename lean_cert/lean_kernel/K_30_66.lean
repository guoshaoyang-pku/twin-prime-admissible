import Sound
import lean_certs.cert_30_66

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H30_gt_66_kernel : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 66 := by
  exact certValidRoot_sound (k := 30) (d := 66) (c := cert_30_66) (by decide)
