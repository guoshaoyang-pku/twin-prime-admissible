import Sound
import lean_certs.cert_39_132

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H39_gt_132_kernel : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 132 := by
  exact certValidRoot_sound (k := 39) (d := 132) (c := cert_39_132) (by decide)
