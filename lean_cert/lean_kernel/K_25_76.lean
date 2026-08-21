import Sound
import lean_certs.cert_25_76

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H25_gt_76_kernel : ¬ ∃ t : List Nat, admissible 25 t = true ∧ diameter t ≤ 76 := by
  exact certValidRoot_sound (k := 25) (d := 76) (c := cert_25_76) (by decide)
