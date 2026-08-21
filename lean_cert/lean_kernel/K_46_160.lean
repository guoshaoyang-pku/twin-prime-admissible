import Sound
import lean_certs.cert_46_160

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H46_gt_160_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 160 := by
  exact certValidRoot_sound (k := 46) (d := 160) (c := cert_46_160) (by decide)
