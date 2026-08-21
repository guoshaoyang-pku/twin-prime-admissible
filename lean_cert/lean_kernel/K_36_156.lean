import Sound
import lean_certs.cert_36_156

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H36_gt_156_kernel : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 156 := by
  exact certValidRoot_sound (k := 36) (d := 156) (c := cert_36_156) (by decide)
