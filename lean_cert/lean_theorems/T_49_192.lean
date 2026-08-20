import Sound
import lean_certs.cert_49_192

open CertVerify

theorem H49_gt_192 : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 192 := by
  exact certValidRoot_sound (k := 49) (d := 192) (c := cert_49_192) (by native_decide)
