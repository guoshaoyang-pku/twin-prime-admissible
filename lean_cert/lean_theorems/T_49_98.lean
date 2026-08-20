import Sound
import lean_certs.cert_49_98

open CertVerify

theorem H49_gt_98 : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 98 := by
  exact certValidRoot_sound (k := 49) (d := 98) (c := cert_49_98) (by native_decide)
