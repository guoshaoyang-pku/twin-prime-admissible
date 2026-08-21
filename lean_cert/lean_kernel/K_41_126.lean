import Sound
import lean_certs.cert_41_126

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H41_gt_126_kernel : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 126 := by
  exact certValidRoot_sound (k := 41) (d := 126) (c := cert_41_126) (by decide)
