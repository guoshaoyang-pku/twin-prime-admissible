import Sound
import lean_certs.cert_50_168

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H50_gt_168_kernel : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 168 := by
  exact certValidRoot_sound (k := 50) (d := 168) (c := cert_50_168) (by decide)
