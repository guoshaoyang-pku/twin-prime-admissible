import Sound
import lean_certs.cert_48_204

open CertVerify

theorem H48_gt_204 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 204 := by
  exact certValidRoot_sound (k := 48) (d := 204) (c := cert_48_204) (by native_decide)
