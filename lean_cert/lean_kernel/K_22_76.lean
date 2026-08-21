import Sound
import lean_certs.cert_22_76

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H22_gt_76_kernel : ¬ ∃ t : List Nat, admissible 22 t = true ∧ diameter t ≤ 76 := by
  exact certValidRoot_sound (k := 22) (d := 76) (c := cert_22_76) (by decide)
