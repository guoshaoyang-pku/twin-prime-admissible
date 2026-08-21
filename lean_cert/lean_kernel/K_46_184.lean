import Sound
import lean_certs.cert_46_184

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H46_gt_184_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 184 := by
  exact certValidRoot_sound (k := 46) (d := 184) (c := cert_46_184) (by decide)
