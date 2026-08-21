import Sound
import lean_certs.cert_48_126

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H48_gt_126_kernel : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 126 := by
  exact certValidRoot_sound (k := 48) (d := 126) (c := cert_48_126) (by decide)
