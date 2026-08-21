import Sound
import lean_certs.cert_50_160

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H50_gt_160_kernel : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 160 := by
  exact certValidRoot_sound (k := 50) (d := 160) (c := cert_50_160) (by decide)
