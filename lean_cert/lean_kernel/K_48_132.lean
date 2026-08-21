import Sound
import lean_certs.cert_48_132

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H48_gt_132_kernel : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 132 := by
  exact certValidRoot_sound (k := 48) (d := 132) (c := cert_48_132) (by decide)
