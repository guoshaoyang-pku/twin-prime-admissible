import Sound
import lean_certs.cert_34_138

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H34_gt_138_kernel : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 138 := by
  exact certValidRoot_sound (k := 34) (d := 138) (c := cert_34_138) (by decide)
