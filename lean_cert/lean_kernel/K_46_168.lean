import Sound
import lean_certs.cert_46_168

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H46_gt_168_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 168 := by
  exact certValidRoot_sound (k := 46) (d := 168) (c := cert_46_168) (by decide)
