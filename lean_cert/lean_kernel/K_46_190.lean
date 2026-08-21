import Sound
import lean_certs.cert_46_190

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H46_gt_190_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 190 := by
  exact certValidRoot_sound (k := 46) (d := 190) (c := cert_46_190) (by decide)
