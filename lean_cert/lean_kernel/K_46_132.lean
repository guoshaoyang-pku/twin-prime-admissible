import Sound
import lean_certs.cert_46_132

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H46_gt_132_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 132 := by
  exact certValidRoot_sound (k := 46) (d := 132) (c := cert_46_132) (by decide)
