import Sound
import lean_certs.cert_50_164

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H50_gt_164_kernel : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 164 := by
  exact certValidRoot_sound (k := 50) (d := 164) (c := cert_50_164) (by decide)
