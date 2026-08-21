import Sound
import lean_certs.cert_50_194

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H50_gt_194_kernel : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 194 := by
  exact certValidRoot_sound (k := 50) (d := 194) (c := cert_50_194) (by decide)
