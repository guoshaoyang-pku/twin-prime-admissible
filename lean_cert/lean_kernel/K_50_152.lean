import Sound
import lean_certs.cert_50_152

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H50_gt_152_kernel : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 152 := by
  exact certValidRoot_sound (k := 50) (d := 152) (c := cert_50_152) (by decide)
