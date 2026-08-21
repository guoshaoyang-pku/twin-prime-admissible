import Sound
import lean_certs.cert_35_76

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H35_gt_76_kernel : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 76 := by
  exact certValidRoot_sound (k := 35) (d := 76) (c := cert_35_76) (by decide)
