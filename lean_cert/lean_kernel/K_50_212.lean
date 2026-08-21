import Sound
import lean_certs.cert_50_212

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H50_gt_212_kernel : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 212 := by
  exact certValidRoot_sound (k := 50) (d := 212) (c := cert_50_212) (by decide)
