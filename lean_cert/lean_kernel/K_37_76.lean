import Sound
import lean_certs.cert_37_76

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H37_gt_76_kernel : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 76 := by
  exact certValidRoot_sound (k := 37) (d := 76) (c := cert_37_76) (by decide)
