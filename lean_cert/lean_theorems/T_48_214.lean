import Sound
import lean_certs.cert_48_214

open CertVerify

theorem H48_gt_214 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 214 := by
  exact certValidRoot_sound (k := 48) (d := 214) (c := cert_48_214) (by native_decide)
