import Sound
import lean_certs.cert_38_76

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H38_gt_76_kernel : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 76 := by
  exact certValidRoot_sound (k := 38) (d := 76) (c := cert_38_76) (by decide)
