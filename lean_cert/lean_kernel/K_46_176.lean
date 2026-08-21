import Sound
import lean_certs.cert_46_176

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H46_gt_176_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 176 := by
  exact certValidRoot_sound (k := 46) (d := 176) (c := cert_46_176) (by decide)
