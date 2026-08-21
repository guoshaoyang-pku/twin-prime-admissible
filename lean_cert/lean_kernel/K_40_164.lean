import Sound
import lean_certs.cert_40_164

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H40_gt_164_kernel : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 164 := by
  exact certValidRoot_sound (k := 40) (d := 164) (c := cert_40_164) (by decide)
