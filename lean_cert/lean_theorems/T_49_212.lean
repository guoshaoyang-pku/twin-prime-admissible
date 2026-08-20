import Sound
import lean_certs.cert_49_212

open CertVerify

theorem H49_gt_212 : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 212 := by
  exact certValidRoot_sound (k := 49) (d := 212) (c := cert_49_212) (by native_decide)
