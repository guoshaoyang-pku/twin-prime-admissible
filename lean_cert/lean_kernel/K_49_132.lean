import Sound
import lean_certs.cert_49_132

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H49_gt_132_kernel : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 132 := by
  exact certValidRoot_sound (k := 49) (d := 132) (c := cert_49_132) (by decide)
