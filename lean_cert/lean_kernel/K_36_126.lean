import Sound
import lean_certs.cert_36_126

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H36_gt_126_kernel : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 126 := by
  exact certValidRoot_sound (k := 36) (d := 126) (c := cert_36_126) (by decide)
