import Sound
import lean_certs.cert_45_186

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H45_gt_186_kernel : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 186 := by
  exact certValidRoot_sound (k := 45) (d := 186) (c := cert_45_186) (by decide)
