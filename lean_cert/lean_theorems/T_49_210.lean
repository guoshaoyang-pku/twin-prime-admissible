import Sound
import lean_certs.cert_49_210

open CertVerify

theorem H49_gt_210 : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 210 := by
  exact certValidRoot_sound (k := 49) (d := 210) (c := cert_49_210) (by native_decide)
