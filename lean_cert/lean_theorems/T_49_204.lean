import Sound
import lean_certs.cert_49_204

open CertVerify

theorem H49_gt_204 : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 204 := by
  exact certValidRoot_sound (k := 49) (d := 204) (c := cert_49_204) (by native_decide)
