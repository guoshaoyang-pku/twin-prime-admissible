import Sound
import lean_certs.cert_40_138

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H40_gt_138_kernel : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 138 := by
  exact certValidRoot_sound (k := 40) (d := 138) (c := cert_40_138) (by decide)
