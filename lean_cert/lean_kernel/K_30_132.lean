import Sound
import lean_certs.cert_30_132

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H30_gt_132_kernel : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 132 := by
  exact certValidRoot_sound (k := 30) (d := 132) (c := cert_30_132) (by decide)
