import Sound
import lean_certs.cert_36_138

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H36_gt_138_kernel : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 138 := by
  exact certValidRoot_sound (k := 36) (d := 138) (c := cert_36_138) (by decide)
