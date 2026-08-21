import Sound
import lean_certs.cert_45_194

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H45_gt_194_kernel : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 194 := by
  exact certValidRoot_sound (k := 45) (d := 194) (c := cert_45_194) (by decide)
