import Sound
import lean_certs.cert_49_186

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H49_gt_186_kernel : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 186 := by
  exact certValidRoot_sound (k := 49) (d := 186) (c := cert_49_186) (by decide)
