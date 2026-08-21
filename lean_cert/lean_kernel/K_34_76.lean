import Sound
import lean_certs.cert_34_76

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H34_gt_76_kernel : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 76 := by
  exact certValidRoot_sound (k := 34) (d := 76) (c := cert_34_76) (by decide)
