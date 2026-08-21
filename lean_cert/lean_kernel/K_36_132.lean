import Sound
import lean_certs.cert_36_132

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H36_gt_132_kernel : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 132 := by
  exact certValidRoot_sound (k := 36) (d := 132) (c := cert_36_132) (by decide)
