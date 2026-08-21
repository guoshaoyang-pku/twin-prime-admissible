import Sound
import lean_certs.cert_46_164

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H46_gt_164_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 164 := by
  exact certValidRoot_sound (k := 46) (d := 164) (c := cert_46_164) (by decide)
