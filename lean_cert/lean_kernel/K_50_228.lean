import Sound
import lean_certs.cert_50_228

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H50_gt_228_kernel : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 228 := by
  exact certValidRoot_sound (k := 50) (d := 228) (c := cert_50_228) (by decide)
