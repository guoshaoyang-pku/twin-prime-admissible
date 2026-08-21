import Sound
import lean_certs.cert_49_194

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H49_gt_194_kernel : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 194 := by
  exact certValidRoot_sound (k := 49) (d := 194) (c := cert_49_194) (by decide)
