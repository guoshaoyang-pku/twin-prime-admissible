import Sound
import lean_certs.cert_49_228

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H49_gt_228_kernel : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 228 := by
  exact certValidRoot_sound (k := 49) (d := 228) (c := cert_49_228) (by decide)
