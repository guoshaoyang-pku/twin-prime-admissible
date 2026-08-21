import Sound
import lean_certs.cert_20_66

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H20_gt_66_kernel : ¬ ∃ t : List Nat, admissible 20 t = true ∧ diameter t ≤ 66 := by
  exact certValidRoot_sound (k := 20) (d := 66) (c := cert_20_66) (by decide)
