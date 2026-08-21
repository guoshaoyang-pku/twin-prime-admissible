import Sound
import lean_certs.cert_50_186

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H50_gt_186_kernel : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 186 := by
  exact certValidRoot_sound (k := 50) (d := 186) (c := cert_50_186) (by decide)
