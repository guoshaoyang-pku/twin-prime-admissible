import Sound
import lean_certs.cert_31_76

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H31_gt_76_kernel : ¬ ∃ t : List Nat, admissible 31 t = true ∧ diameter t ≤ 76 := by
  exact certValidRoot_sound (k := 31) (d := 76) (c := cert_31_76) (by decide)
