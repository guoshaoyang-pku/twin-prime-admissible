import Sound
import lean_certs.cert_48_186

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H48_gt_186_kernel : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 186 := by
  exact certValidRoot_sound (k := 48) (d := 186) (c := cert_48_186) (by decide)
