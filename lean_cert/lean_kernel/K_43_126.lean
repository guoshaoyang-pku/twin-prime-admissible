import Sound
import lean_certs.cert_43_126

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H43_gt_126_kernel : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 126 := by
  exact certValidRoot_sound (k := 43) (d := 126) (c := cert_43_126) (by decide)
