import Sound
import lean_certs.cert_46_192

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H46_gt_192_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 192 := by
  exact certValidRoot_sound (k := 46) (d := 192) (c := cert_46_192) (by decide)
