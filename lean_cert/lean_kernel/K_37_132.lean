import Sound
import lean_certs.cert_37_132

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H37_gt_132_kernel : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 132 := by
  exact certValidRoot_sound (k := 37) (d := 132) (c := cert_37_132) (by decide)
