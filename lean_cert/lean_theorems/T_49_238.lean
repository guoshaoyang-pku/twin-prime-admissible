import Sound
import lean_certs.cert_49_238

open CertVerify

theorem H49_gt_238 : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 238 := by
  exact certValidRoot_sound (k := 49) (d := 238) (c := cert_49_238) (by native_decide)
