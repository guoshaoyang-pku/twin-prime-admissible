import Sound
import lean_certs.cert_24_76

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H24_gt_76_kernel : ¬ ∃ t : List Nat, admissible 24 t = true ∧ diameter t ≤ 76 := by
  exact certValidRoot_sound (k := 24) (d := 76) (c := cert_24_76) (by decide)
